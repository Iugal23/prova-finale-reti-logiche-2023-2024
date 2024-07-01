-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_653 is
end project_tb_653;

architecture project_tb_arch_653 of project_tb_653 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 428;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (128,0,0,0,126,0,0,0,77,0,26,0,27,0,130,0,112,0,27,0,193,0,0,0,252,0,63,0,250,0,166,0,249,0,0,0,199,0,184,0,97,0,142,0,226,0,36,0,75,0,108,0,64,0,36,0,49,0,157,0,162,0,84,0,213,0,131,0,6,0,39,0,204,0,0,0,185,0,46,0,200,0,67,0,228,0,172,0,5,0,177,0,140,0,231,0,0,0,98,0,57,0,159,0,233,0,0,0,208,0,0,0,172,0,0,0,0,0,168,0,36,0,72,0,141,0,205,0,116,0,184,0,170,0,191,0,132,0,219,0,155,0,240,0,150,0,163,0,97,0,94,0,0,0,251,0,97,0,81,0,0,0,1,0,0,0,112,0,33,0,88,0,135,0,239,0,187,0,37,0,156,0,158,0,0,0,68,0,191,0,5,0,70,0,42,0,177,0,159,0,31,0,189,0,162,0,154,0,118,0,243,0,0,0,34,0,254,0,0,0,245,0,209,0,110,0,0,0,0,0,0,0,0,0,54,0,202,0,0,0,0,0,3,0,0,0,0,0,68,0,78,0,38,0,0,0,88,0,54,0,225,0,187,0,21,0,40,0,0,0,141,0,66,0,173,0,16,0,208,0,0,0,8,0,126,0,61,0,27,0,5,0,0,0,0,0,133,0,108,0,125,0,163,0,153,0,199,0,0,0,132,0,0,0,6,0,107,0,0,0,62,0,7,0,133,0,95,0,118,0,24,0,0,0,0,0,174,0,195,0,226,0,223,0,169,0,251,0,101,0,107,0,0,0,58,0,87,0,0,0,179,0,85,0,242,0,0,0,249,0,0,0,178,0,68,0,65,0,182,0,94,0,49,0,245,0,210,0,0,0,216,0,193,0,138,0,9,0,54,0,38,0,71,0,108,0,0,0,201,0,231,0,21,0,141,0,0,0,0,0,79,0,250,0,61,0,53,0,252,0,242,0,0,0,0,0,113,0,98,0,117,0,12,0,181,0,218,0,148,0,196,0,0,0,173,0,0,0,75,0,253,0,0,0,0,0,50,0,50,0,29,0,79,0,5,0,9,0,192,0,43,0,30,0,0,0,64,0,0,0,118,0,223,0,179,0,191,0,185,0,26,0,121,0,125,0,130,0,0,0,145,0,231,0,251,0,94,0,66,0,0,0,0,0,29,0,44,0,0,0,0,0,0,0,193,0,0,0,20,0,168,0,188,0,16,0,95,0,114,0,179,0,63,0,112,0,239,0,162,0,64,0,206,0,180,0,180,0,186,0,208,0,0,0,113,0,0,0,117,0,23,0,0,0,0,0,0,0,132,0,111,0,161,0,58,0,47,0,176,0,139,0,0,0,109,0,0,0,166,0,217,0,24,0,128,0,0,0,205,0,131,0,233,0,168,0,2,0,0,0,0,0,76,0,192,0,51,0,185,0,16,0,0,0,33,0,57,0,0,0,0,0,190,0,0,0,84,0,36,0,35,0,4,0,16,0,184,0,176,0,241,0,156,0,69,0,0,0,0,0,132,0,168,0,58,0,220,0,17,0,145,0,152,0,227,0,6,0,240,0,93,0,130,0,194,0,51,0,0,0,30,0,0,0,241,0,200,0,161,0,10,0,120,0,174,0,0,0,216,0,163,0,0,0,245,0,252,0,116,0,0,0,169,0,185,0,66,0,116,0,61,0,138,0,0,0,136,0,0,0,51,0,229,0,162,0,191,0,250,0,220,0,114,0,93,0,248,0,155,0,44,0,0,0,63,0,106,0,0,0,21,0,158,0,0,0,0,0,42,0,171,0,0,0,251,0,203,0,94,0,141,0,220,0,0,0,0,0,0,0,227,0,6,0,198,0,0,0,169,0,0,0,12,0,0,0,155,0,0,0,193,0,90,0,0,0,47,0,108,0,206,0,200,0,9,0);
signal scenario_full  : scenario_type := (128,31,128,30,126,31,126,30,77,31,26,31,27,31,130,31,112,31,27,31,193,31,193,30,252,31,63,31,250,31,166,31,249,31,249,30,199,31,184,31,97,31,142,31,226,31,36,31,75,31,108,31,64,31,36,31,49,31,157,31,162,31,84,31,213,31,131,31,6,31,39,31,204,31,204,30,185,31,46,31,200,31,67,31,228,31,172,31,5,31,177,31,140,31,231,31,231,30,98,31,57,31,159,31,233,31,233,30,208,31,208,30,172,31,172,30,172,29,168,31,36,31,72,31,141,31,205,31,116,31,184,31,170,31,191,31,132,31,219,31,155,31,240,31,150,31,163,31,97,31,94,31,94,30,251,31,97,31,81,31,81,30,1,31,1,30,112,31,33,31,88,31,135,31,239,31,187,31,37,31,156,31,158,31,158,30,68,31,191,31,5,31,70,31,42,31,177,31,159,31,31,31,189,31,162,31,154,31,118,31,243,31,243,30,34,31,254,31,254,30,245,31,209,31,110,31,110,30,110,29,110,28,110,27,54,31,202,31,202,30,202,29,3,31,3,30,3,29,68,31,78,31,38,31,38,30,88,31,54,31,225,31,187,31,21,31,40,31,40,30,141,31,66,31,173,31,16,31,208,31,208,30,8,31,126,31,61,31,27,31,5,31,5,30,5,29,133,31,108,31,125,31,163,31,153,31,199,31,199,30,132,31,132,30,6,31,107,31,107,30,62,31,7,31,133,31,95,31,118,31,24,31,24,30,24,29,174,31,195,31,226,31,223,31,169,31,251,31,101,31,107,31,107,30,58,31,87,31,87,30,179,31,85,31,242,31,242,30,249,31,249,30,178,31,68,31,65,31,182,31,94,31,49,31,245,31,210,31,210,30,216,31,193,31,138,31,9,31,54,31,38,31,71,31,108,31,108,30,201,31,231,31,21,31,141,31,141,30,141,29,79,31,250,31,61,31,53,31,252,31,242,31,242,30,242,29,113,31,98,31,117,31,12,31,181,31,218,31,148,31,196,31,196,30,173,31,173,30,75,31,253,31,253,30,253,29,50,31,50,31,29,31,79,31,5,31,9,31,192,31,43,31,30,31,30,30,64,31,64,30,118,31,223,31,179,31,191,31,185,31,26,31,121,31,125,31,130,31,130,30,145,31,231,31,251,31,94,31,66,31,66,30,66,29,29,31,44,31,44,30,44,29,44,28,193,31,193,30,20,31,168,31,188,31,16,31,95,31,114,31,179,31,63,31,112,31,239,31,162,31,64,31,206,31,180,31,180,31,186,31,208,31,208,30,113,31,113,30,117,31,23,31,23,30,23,29,23,28,132,31,111,31,161,31,58,31,47,31,176,31,139,31,139,30,109,31,109,30,166,31,217,31,24,31,128,31,128,30,205,31,131,31,233,31,168,31,2,31,2,30,2,29,76,31,192,31,51,31,185,31,16,31,16,30,33,31,57,31,57,30,57,29,190,31,190,30,84,31,36,31,35,31,4,31,16,31,184,31,176,31,241,31,156,31,69,31,69,30,69,29,132,31,168,31,58,31,220,31,17,31,145,31,152,31,227,31,6,31,240,31,93,31,130,31,194,31,51,31,51,30,30,31,30,30,241,31,200,31,161,31,10,31,120,31,174,31,174,30,216,31,163,31,163,30,245,31,252,31,116,31,116,30,169,31,185,31,66,31,116,31,61,31,138,31,138,30,136,31,136,30,51,31,229,31,162,31,191,31,250,31,220,31,114,31,93,31,248,31,155,31,44,31,44,30,63,31,106,31,106,30,21,31,158,31,158,30,158,29,42,31,171,31,171,30,251,31,203,31,94,31,141,31,220,31,220,30,220,29,220,28,227,31,6,31,198,31,198,30,169,31,169,30,12,31,12,30,155,31,155,30,193,31,90,31,90,30,47,31,108,31,206,31,200,31,9,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
