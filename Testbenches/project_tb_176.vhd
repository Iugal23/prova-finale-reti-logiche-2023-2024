-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 603;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,232,0,215,0,159,0,126,0,238,0,74,0,16,0,0,0,0,0,78,0,180,0,43,0,64,0,0,0,0,0,216,0,116,0,128,0,88,0,171,0,0,0,168,0,235,0,200,0,1,0,0,0,0,0,15,0,100,0,75,0,0,0,42,0,20,0,118,0,243,0,153,0,179,0,228,0,0,0,0,0,250,0,0,0,59,0,16,0,35,0,0,0,140,0,89,0,9,0,30,0,85,0,56,0,107,0,104,0,240,0,187,0,0,0,92,0,0,0,231,0,104,0,101,0,195,0,0,0,191,0,216,0,0,0,82,0,0,0,0,0,0,0,118,0,149,0,134,0,220,0,45,0,0,0,203,0,108,0,51,0,22,0,0,0,2,0,0,0,187,0,149,0,219,0,133,0,22,0,198,0,237,0,0,0,209,0,41,0,34,0,139,0,152,0,165,0,34,0,205,0,26,0,210,0,1,0,176,0,136,0,88,0,0,0,18,0,0,0,57,0,73,0,217,0,0,0,167,0,53,0,25,0,0,0,41,0,0,0,0,0,129,0,213,0,106,0,255,0,88,0,204,0,37,0,46,0,233,0,0,0,142,0,200,0,0,0,21,0,48,0,147,0,33,0,0,0,242,0,0,0,200,0,214,0,22,0,36,0,50,0,188,0,0,0,232,0,138,0,37,0,91,0,153,0,171,0,243,0,182,0,150,0,214,0,170,0,184,0,114,0,20,0,107,0,132,0,70,0,0,0,119,0,218,0,160,0,242,0,65,0,0,0,0,0,0,0,1,0,55,0,242,0,143,0,0,0,0,0,107,0,213,0,0,0,193,0,0,0,0,0,201,0,126,0,141,0,152,0,162,0,0,0,0,0,88,0,0,0,237,0,137,0,220,0,163,0,0,0,9,0,27,0,238,0,192,0,89,0,0,0,53,0,207,0,219,0,115,0,22,0,0,0,248,0,94,0,184,0,17,0,253,0,85,0,119,0,128,0,185,0,146,0,176,0,184,0,208,0,11,0,7,0,176,0,77,0,113,0,83,0,147,0,134,0,25,0,217,0,94,0,109,0,88,0,0,0,18,0,0,0,171,0,170,0,149,0,179,0,0,0,175,0,64,0,163,0,182,0,206,0,222,0,148,0,164,0,148,0,220,0,17,0,0,0,177,0,1,0,10,0,152,0,81,0,0,0,84,0,220,0,0,0,110,0,0,0,248,0,215,0,205,0,217,0,53,0,80,0,218,0,204,0,0,0,79,0,126,0,84,0,30,0,39,0,38,0,159,0,0,0,84,0,155,0,18,0,65,0,71,0,106,0,110,0,63,0,0,0,30,0,0,0,43,0,0,0,44,0,43,0,109,0,93,0,0,0,241,0,47,0,72,0,52,0,22,0,248,0,226,0,0,0,81,0,189,0,42,0,131,0,115,0,0,0,0,0,139,0,49,0,197,0,11,0,0,0,0,0,34,0,70,0,9,0,3,0,101,0,176,0,248,0,15,0,191,0,9,0,73,0,137,0,28,0,0,0,107,0,0,0,169,0,197,0,189,0,15,0,16,0,0,0,229,0,88,0,233,0,79,0,0,0,132,0,0,0,144,0,0,0,58,0,96,0,149,0,0,0,42,0,143,0,151,0,46,0,106,0,0,0,132,0,15,0,10,0,166,0,183,0,226,0,104,0,67,0,0,0,0,0,0,0,35,0,159,0,0,0,133,0,123,0,122,0,251,0,0,0,77,0,0,0,237,0,90,0,60,0,94,0,75,0,111,0,252,0,0,0,217,0,2,0,0,0,172,0,82,0,0,0,0,0,109,0,42,0,28,0,12,0,145,0,0,0,191,0,41,0,160,0,0,0,172,0,182,0,0,0,130,0,199,0,0,0,164,0,209,0,72,0,83,0,199,0,241,0,56,0,63,0,241,0,6,0,0,0,35,0,0,0,141,0,0,0,0,0,88,0,219,0,168,0,28,0,13,0,0,0,86,0,27,0,146,0,108,0,36,0,126,0,166,0,174,0,40,0,140,0,76,0,97,0,207,0,95,0,155,0,117,0,0,0,255,0,116,0,0,0,75,0,116,0,229,0,94,0,125,0,54,0,112,0,204,0,138,0,85,0,32,0,245,0,207,0,151,0,14,0,0,0,74,0,207,0,83,0,105,0,216,0,0,0,218,0,0,0,171,0,24,0,49,0,186,0,171,0,0,0,0,0,168,0,195,0,155,0,193,0,158,0,74,0,185,0,137,0,0,0,223,0,199,0,141,0,138,0,0,0,0,0,0,0,105,0,46,0,238,0,65,0,9,0,56,0,28,0,223,0,9,0,0,0,146,0,91,0,0,0,79,0,149,0,181,0,83,0,31,0,173,0,0,0,81,0,0,0,48,0,0,0,91,0,77,0,99,0,100,0,56,0,0,0,0,0,96,0,184,0,0,0,169,0,34,0,246,0,168,0,0,0,208,0,0,0,223,0,84,0,0,0,227,0,100,0,0,0,142,0,36,0,36,0,28,0,0,0,23,0,31,0,197,0,233,0,116,0,0,0,253,0,100,0,179,0,236,0,150,0,0,0,246,0,154,0,222,0,163,0,216,0,184,0,62,0,90,0,0,0,154,0,193,0,231,0,101,0,142,0,24,0,242,0,111,0,0,0,0,0,235,0,93,0,0,0,206,0,200,0,91,0,94,0,211,0,42,0,6,0,130,0,249,0,0,0);
signal scenario_full  : scenario_type := (0,0,232,31,215,31,159,31,126,31,238,31,74,31,16,31,16,30,16,29,78,31,180,31,43,31,64,31,64,30,64,29,216,31,116,31,128,31,88,31,171,31,171,30,168,31,235,31,200,31,1,31,1,30,1,29,15,31,100,31,75,31,75,30,42,31,20,31,118,31,243,31,153,31,179,31,228,31,228,30,228,29,250,31,250,30,59,31,16,31,35,31,35,30,140,31,89,31,9,31,30,31,85,31,56,31,107,31,104,31,240,31,187,31,187,30,92,31,92,30,231,31,104,31,101,31,195,31,195,30,191,31,216,31,216,30,82,31,82,30,82,29,82,28,118,31,149,31,134,31,220,31,45,31,45,30,203,31,108,31,51,31,22,31,22,30,2,31,2,30,187,31,149,31,219,31,133,31,22,31,198,31,237,31,237,30,209,31,41,31,34,31,139,31,152,31,165,31,34,31,205,31,26,31,210,31,1,31,176,31,136,31,88,31,88,30,18,31,18,30,57,31,73,31,217,31,217,30,167,31,53,31,25,31,25,30,41,31,41,30,41,29,129,31,213,31,106,31,255,31,88,31,204,31,37,31,46,31,233,31,233,30,142,31,200,31,200,30,21,31,48,31,147,31,33,31,33,30,242,31,242,30,200,31,214,31,22,31,36,31,50,31,188,31,188,30,232,31,138,31,37,31,91,31,153,31,171,31,243,31,182,31,150,31,214,31,170,31,184,31,114,31,20,31,107,31,132,31,70,31,70,30,119,31,218,31,160,31,242,31,65,31,65,30,65,29,65,28,1,31,55,31,242,31,143,31,143,30,143,29,107,31,213,31,213,30,193,31,193,30,193,29,201,31,126,31,141,31,152,31,162,31,162,30,162,29,88,31,88,30,237,31,137,31,220,31,163,31,163,30,9,31,27,31,238,31,192,31,89,31,89,30,53,31,207,31,219,31,115,31,22,31,22,30,248,31,94,31,184,31,17,31,253,31,85,31,119,31,128,31,185,31,146,31,176,31,184,31,208,31,11,31,7,31,176,31,77,31,113,31,83,31,147,31,134,31,25,31,217,31,94,31,109,31,88,31,88,30,18,31,18,30,171,31,170,31,149,31,179,31,179,30,175,31,64,31,163,31,182,31,206,31,222,31,148,31,164,31,148,31,220,31,17,31,17,30,177,31,1,31,10,31,152,31,81,31,81,30,84,31,220,31,220,30,110,31,110,30,248,31,215,31,205,31,217,31,53,31,80,31,218,31,204,31,204,30,79,31,126,31,84,31,30,31,39,31,38,31,159,31,159,30,84,31,155,31,18,31,65,31,71,31,106,31,110,31,63,31,63,30,30,31,30,30,43,31,43,30,44,31,43,31,109,31,93,31,93,30,241,31,47,31,72,31,52,31,22,31,248,31,226,31,226,30,81,31,189,31,42,31,131,31,115,31,115,30,115,29,139,31,49,31,197,31,11,31,11,30,11,29,34,31,70,31,9,31,3,31,101,31,176,31,248,31,15,31,191,31,9,31,73,31,137,31,28,31,28,30,107,31,107,30,169,31,197,31,189,31,15,31,16,31,16,30,229,31,88,31,233,31,79,31,79,30,132,31,132,30,144,31,144,30,58,31,96,31,149,31,149,30,42,31,143,31,151,31,46,31,106,31,106,30,132,31,15,31,10,31,166,31,183,31,226,31,104,31,67,31,67,30,67,29,67,28,35,31,159,31,159,30,133,31,123,31,122,31,251,31,251,30,77,31,77,30,237,31,90,31,60,31,94,31,75,31,111,31,252,31,252,30,217,31,2,31,2,30,172,31,82,31,82,30,82,29,109,31,42,31,28,31,12,31,145,31,145,30,191,31,41,31,160,31,160,30,172,31,182,31,182,30,130,31,199,31,199,30,164,31,209,31,72,31,83,31,199,31,241,31,56,31,63,31,241,31,6,31,6,30,35,31,35,30,141,31,141,30,141,29,88,31,219,31,168,31,28,31,13,31,13,30,86,31,27,31,146,31,108,31,36,31,126,31,166,31,174,31,40,31,140,31,76,31,97,31,207,31,95,31,155,31,117,31,117,30,255,31,116,31,116,30,75,31,116,31,229,31,94,31,125,31,54,31,112,31,204,31,138,31,85,31,32,31,245,31,207,31,151,31,14,31,14,30,74,31,207,31,83,31,105,31,216,31,216,30,218,31,218,30,171,31,24,31,49,31,186,31,171,31,171,30,171,29,168,31,195,31,155,31,193,31,158,31,74,31,185,31,137,31,137,30,223,31,199,31,141,31,138,31,138,30,138,29,138,28,105,31,46,31,238,31,65,31,9,31,56,31,28,31,223,31,9,31,9,30,146,31,91,31,91,30,79,31,149,31,181,31,83,31,31,31,173,31,173,30,81,31,81,30,48,31,48,30,91,31,77,31,99,31,100,31,56,31,56,30,56,29,96,31,184,31,184,30,169,31,34,31,246,31,168,31,168,30,208,31,208,30,223,31,84,31,84,30,227,31,100,31,100,30,142,31,36,31,36,31,28,31,28,30,23,31,31,31,197,31,233,31,116,31,116,30,253,31,100,31,179,31,236,31,150,31,150,30,246,31,154,31,222,31,163,31,216,31,184,31,62,31,90,31,90,30,154,31,193,31,231,31,101,31,142,31,24,31,242,31,111,31,111,30,111,29,235,31,93,31,93,30,206,31,200,31,91,31,94,31,211,31,42,31,6,31,130,31,249,31,249,30);

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
