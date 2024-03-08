-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_696 is
end project_tb_696;

architecture project_tb_arch_696 of project_tb_696 is
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

constant SCENARIO_LENGTH : integer := 619;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (24,0,210,0,234,0,30,0,222,0,41,0,146,0,254,0,160,0,14,0,250,0,191,0,191,0,0,0,76,0,2,0,44,0,130,0,154,0,24,0,0,0,22,0,49,0,0,0,157,0,169,0,217,0,109,0,27,0,0,0,40,0,175,0,169,0,0,0,176,0,0,0,119,0,246,0,130,0,20,0,223,0,211,0,0,0,184,0,167,0,96,0,255,0,251,0,173,0,81,0,216,0,75,0,25,0,181,0,0,0,3,0,238,0,19,0,251,0,234,0,5,0,209,0,252,0,168,0,215,0,107,0,88,0,138,0,84,0,110,0,0,0,0,0,207,0,0,0,248,0,144,0,0,0,134,0,233,0,179,0,118,0,22,0,15,0,83,0,84,0,73,0,0,0,70,0,142,0,117,0,0,0,0,0,27,0,136,0,0,0,228,0,0,0,232,0,172,0,113,0,98,0,0,0,0,0,0,0,140,0,207,0,0,0,0,0,247,0,227,0,131,0,184,0,168,0,225,0,123,0,210,0,81,0,0,0,0,0,69,0,172,0,199,0,116,0,0,0,0,0,57,0,230,0,0,0,65,0,55,0,209,0,154,0,174,0,0,0,136,0,64,0,150,0,252,0,46,0,214,0,190,0,175,0,1,0,0,0,228,0,84,0,71,0,0,0,213,0,229,0,0,0,0,0,164,0,135,0,0,0,225,0,198,0,166,0,231,0,0,0,206,0,0,0,238,0,24,0,0,0,0,0,0,0,185,0,113,0,184,0,126,0,167,0,0,0,201,0,135,0,222,0,175,0,89,0,0,0,29,0,0,0,0,0,99,0,202,0,4,0,54,0,0,0,90,0,33,0,253,0,0,0,216,0,158,0,11,0,15,0,0,0,58,0,11,0,0,0,0,0,0,0,13,0,167,0,199,0,16,0,0,0,52,0,220,0,166,0,93,0,32,0,244,0,0,0,200,0,6,0,188,0,238,0,233,0,246,0,173,0,118,0,68,0,145,0,221,0,236,0,85,0,0,0,210,0,0,0,3,0,218,0,244,0,0,0,238,0,235,0,0,0,229,0,127,0,0,0,110,0,56,0,0,0,0,0,127,0,147,0,0,0,64,0,72,0,0,0,116,0,115,0,0,0,39,0,38,0,172,0,80,0,0,0,152,0,132,0,27,0,101,0,223,0,50,0,243,0,29,0,186,0,31,0,23,0,144,0,249,0,246,0,84,0,0,0,119,0,171,0,0,0,137,0,9,0,156,0,73,0,0,0,242,0,168,0,238,0,44,0,52,0,0,0,93,0,0,0,108,0,203,0,155,0,125,0,163,0,0,0,170,0,0,0,118,0,5,0,167,0,34,0,9,0,240,0,48,0,2,0,13,0,71,0,21,0,135,0,79,0,121,0,0,0,130,0,0,0,111,0,217,0,0,0,16,0,0,0,222,0,99,0,70,0,92,0,37,0,184,0,88,0,187,0,57,0,225,0,154,0,167,0,152,0,152,0,0,0,0,0,136,0,61,0,2,0,85,0,0,0,0,0,145,0,0,0,127,0,185,0,31,0,164,0,89,0,38,0,107,0,0,0,54,0,162,0,49,0,158,0,179,0,252,0,0,0,41,0,112,0,87,0,0,0,57,0,141,0,196,0,45,0,174,0,92,0,148,0,191,0,216,0,196,0,36,0,153,0,129,0,56,0,184,0,44,0,141,0,0,0,1,0,120,0,94,0,57,0,0,0,124,0,0,0,55,0,182,0,122,0,211,0,154,0,185,0,209,0,180,0,0,0,192,0,36,0,0,0,77,0,152,0,30,0,100,0,140,0,91,0,59,0,0,0,174,0,129,0,168,0,146,0,159,0,92,0,182,0,0,0,69,0,100,0,191,0,44,0,124,0,199,0,199,0,155,0,120,0,170,0,0,0,91,0,181,0,0,0,169,0,14,0,176,0,231,0,97,0,61,0,84,0,77,0,202,0,231,0,102,0,108,0,244,0,0,0,0,0,50,0,142,0,25,0,218,0,1,0,174,0,165,0,50,0,84,0,199,0,147,0,212,0,108,0,9,0,229,0,0,0,189,0,240,0,189,0,62,0,249,0,176,0,84,0,165,0,134,0,82,0,146,0,0,0,147,0,56,0,202,0,171,0,30,0,42,0,30,0,212,0,227,0,0,0,32,0,0,0,0,0,42,0,49,0,0,0,219,0,139,0,0,0,120,0,99,0,201,0,201,0,201,0,0,0,159,0,142,0,211,0,0,0,128,0,128,0,177,0,17,0,0,0,246,0,59,0,174,0,0,0,0,0,187,0,1,0,152,0,237,0,135,0,14,0,203,0,0,0,72,0,0,0,36,0,67,0,100,0,201,0,221,0,0,0,0,0,0,0,74,0,52,0,0,0,108,0,151,0,24,0,193,0,244,0,0,0,3,0,0,0,0,0,88,0,54,0,134,0,40,0,0,0,236,0,192,0,231,0,27,0,243,0,228,0,64,0,154,0,0,0,0,0,161,0,241,0,16,0,208,0,56,0,13,0,0,0,0,0,169,0,227,0,206,0,64,0,0,0,1,0,95,0,141,0,234,0,72,0,6,0,244,0,120,0,26,0,205,0,206,0,26,0,126,0,177,0,0,0,4,0,92,0,40,0,67,0,0,0,88,0,96,0,183,0,71,0,141,0,0,0,0,0,0,0,202,0,142,0,17,0,230,0,153,0,112,0,112,0,0,0,65,0,37,0,0,0,146,0,59,0,243,0,76,0,56,0,71,0,191,0,252,0,35,0,12,0,40,0);
signal scenario_full  : scenario_type := (24,31,210,31,234,31,30,31,222,31,41,31,146,31,254,31,160,31,14,31,250,31,191,31,191,31,191,30,76,31,2,31,44,31,130,31,154,31,24,31,24,30,22,31,49,31,49,30,157,31,169,31,217,31,109,31,27,31,27,30,40,31,175,31,169,31,169,30,176,31,176,30,119,31,246,31,130,31,20,31,223,31,211,31,211,30,184,31,167,31,96,31,255,31,251,31,173,31,81,31,216,31,75,31,25,31,181,31,181,30,3,31,238,31,19,31,251,31,234,31,5,31,209,31,252,31,168,31,215,31,107,31,88,31,138,31,84,31,110,31,110,30,110,29,207,31,207,30,248,31,144,31,144,30,134,31,233,31,179,31,118,31,22,31,15,31,83,31,84,31,73,31,73,30,70,31,142,31,117,31,117,30,117,29,27,31,136,31,136,30,228,31,228,30,232,31,172,31,113,31,98,31,98,30,98,29,98,28,140,31,207,31,207,30,207,29,247,31,227,31,131,31,184,31,168,31,225,31,123,31,210,31,81,31,81,30,81,29,69,31,172,31,199,31,116,31,116,30,116,29,57,31,230,31,230,30,65,31,55,31,209,31,154,31,174,31,174,30,136,31,64,31,150,31,252,31,46,31,214,31,190,31,175,31,1,31,1,30,228,31,84,31,71,31,71,30,213,31,229,31,229,30,229,29,164,31,135,31,135,30,225,31,198,31,166,31,231,31,231,30,206,31,206,30,238,31,24,31,24,30,24,29,24,28,185,31,113,31,184,31,126,31,167,31,167,30,201,31,135,31,222,31,175,31,89,31,89,30,29,31,29,30,29,29,99,31,202,31,4,31,54,31,54,30,90,31,33,31,253,31,253,30,216,31,158,31,11,31,15,31,15,30,58,31,11,31,11,30,11,29,11,28,13,31,167,31,199,31,16,31,16,30,52,31,220,31,166,31,93,31,32,31,244,31,244,30,200,31,6,31,188,31,238,31,233,31,246,31,173,31,118,31,68,31,145,31,221,31,236,31,85,31,85,30,210,31,210,30,3,31,218,31,244,31,244,30,238,31,235,31,235,30,229,31,127,31,127,30,110,31,56,31,56,30,56,29,127,31,147,31,147,30,64,31,72,31,72,30,116,31,115,31,115,30,39,31,38,31,172,31,80,31,80,30,152,31,132,31,27,31,101,31,223,31,50,31,243,31,29,31,186,31,31,31,23,31,144,31,249,31,246,31,84,31,84,30,119,31,171,31,171,30,137,31,9,31,156,31,73,31,73,30,242,31,168,31,238,31,44,31,52,31,52,30,93,31,93,30,108,31,203,31,155,31,125,31,163,31,163,30,170,31,170,30,118,31,5,31,167,31,34,31,9,31,240,31,48,31,2,31,13,31,71,31,21,31,135,31,79,31,121,31,121,30,130,31,130,30,111,31,217,31,217,30,16,31,16,30,222,31,99,31,70,31,92,31,37,31,184,31,88,31,187,31,57,31,225,31,154,31,167,31,152,31,152,31,152,30,152,29,136,31,61,31,2,31,85,31,85,30,85,29,145,31,145,30,127,31,185,31,31,31,164,31,89,31,38,31,107,31,107,30,54,31,162,31,49,31,158,31,179,31,252,31,252,30,41,31,112,31,87,31,87,30,57,31,141,31,196,31,45,31,174,31,92,31,148,31,191,31,216,31,196,31,36,31,153,31,129,31,56,31,184,31,44,31,141,31,141,30,1,31,120,31,94,31,57,31,57,30,124,31,124,30,55,31,182,31,122,31,211,31,154,31,185,31,209,31,180,31,180,30,192,31,36,31,36,30,77,31,152,31,30,31,100,31,140,31,91,31,59,31,59,30,174,31,129,31,168,31,146,31,159,31,92,31,182,31,182,30,69,31,100,31,191,31,44,31,124,31,199,31,199,31,155,31,120,31,170,31,170,30,91,31,181,31,181,30,169,31,14,31,176,31,231,31,97,31,61,31,84,31,77,31,202,31,231,31,102,31,108,31,244,31,244,30,244,29,50,31,142,31,25,31,218,31,1,31,174,31,165,31,50,31,84,31,199,31,147,31,212,31,108,31,9,31,229,31,229,30,189,31,240,31,189,31,62,31,249,31,176,31,84,31,165,31,134,31,82,31,146,31,146,30,147,31,56,31,202,31,171,31,30,31,42,31,30,31,212,31,227,31,227,30,32,31,32,30,32,29,42,31,49,31,49,30,219,31,139,31,139,30,120,31,99,31,201,31,201,31,201,31,201,30,159,31,142,31,211,31,211,30,128,31,128,31,177,31,17,31,17,30,246,31,59,31,174,31,174,30,174,29,187,31,1,31,152,31,237,31,135,31,14,31,203,31,203,30,72,31,72,30,36,31,67,31,100,31,201,31,221,31,221,30,221,29,221,28,74,31,52,31,52,30,108,31,151,31,24,31,193,31,244,31,244,30,3,31,3,30,3,29,88,31,54,31,134,31,40,31,40,30,236,31,192,31,231,31,27,31,243,31,228,31,64,31,154,31,154,30,154,29,161,31,241,31,16,31,208,31,56,31,13,31,13,30,13,29,169,31,227,31,206,31,64,31,64,30,1,31,95,31,141,31,234,31,72,31,6,31,244,31,120,31,26,31,205,31,206,31,26,31,126,31,177,31,177,30,4,31,92,31,40,31,67,31,67,30,88,31,96,31,183,31,71,31,141,31,141,30,141,29,141,28,202,31,142,31,17,31,230,31,153,31,112,31,112,31,112,30,65,31,37,31,37,30,146,31,59,31,243,31,76,31,56,31,71,31,191,31,252,31,35,31,12,31,40,31);

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
