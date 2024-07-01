-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_500 is
end project_tb_500;

architecture project_tb_arch_500 of project_tb_500 is
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

constant SCENARIO_LENGTH : integer := 574;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,167,0,201,0,51,0,37,0,176,0,47,0,128,0,143,0,0,0,0,0,212,0,0,0,69,0,15,0,135,0,0,0,136,0,111,0,73,0,199,0,89,0,0,0,0,0,0,0,74,0,92,0,18,0,0,0,0,0,0,0,95,0,0,0,91,0,168,0,206,0,76,0,250,0,231,0,230,0,222,0,0,0,0,0,102,0,202,0,150,0,0,0,104,0,35,0,139,0,98,0,199,0,111,0,251,0,249,0,0,0,0,0,37,0,0,0,42,0,197,0,172,0,13,0,205,0,180,0,191,0,162,0,113,0,83,0,0,0,217,0,96,0,69,0,0,0,131,0,225,0,11,0,91,0,202,0,10,0,0,0,0,0,77,0,68,0,45,0,179,0,55,0,194,0,24,0,0,0,7,0,110,0,0,0,0,0,0,0,159,0,191,0,0,0,18,0,0,0,0,0,0,0,141,0,254,0,0,0,215,0,220,0,70,0,141,0,0,0,17,0,115,0,191,0,83,0,223,0,198,0,0,0,225,0,5,0,93,0,0,0,231,0,157,0,181,0,30,0,108,0,0,0,174,0,131,0,131,0,0,0,162,0,67,0,60,0,57,0,0,0,0,0,135,0,249,0,40,0,197,0,102,0,39,0,222,0,0,0,90,0,0,0,179,0,61,0,230,0,70,0,1,0,64,0,214,0,111,0,3,0,21,0,36,0,132,0,132,0,0,0,14,0,0,0,60,0,213,0,6,0,63,0,90,0,232,0,242,0,201,0,0,0,212,0,66,0,91,0,26,0,169,0,114,0,105,0,250,0,138,0,0,0,145,0,0,0,251,0,0,0,31,0,98,0,87,0,0,0,193,0,137,0,0,0,41,0,224,0,0,0,25,0,220,0,226,0,250,0,157,0,56,0,0,0,32,0,82,0,0,0,169,0,163,0,120,0,115,0,16,0,0,0,188,0,159,0,65,0,169,0,0,0,19,0,78,0,160,0,158,0,92,0,162,0,228,0,136,0,252,0,157,0,243,0,2,0,78,0,134,0,248,0,69,0,0,0,84,0,223,0,69,0,0,0,179,0,221,0,0,0,0,0,199,0,216,0,67,0,0,0,161,0,68,0,0,0,177,0,62,0,0,0,228,0,70,0,138,0,15,0,0,0,97,0,53,0,62,0,165,0,44,0,106,0,121,0,160,0,95,0,116,0,10,0,156,0,183,0,95,0,235,0,0,0,135,0,0,0,100,0,211,0,246,0,34,0,60,0,45,0,226,0,86,0,211,0,220,0,11,0,0,0,65,0,99,0,229,0,0,0,0,0,251,0,0,0,59,0,127,0,66,0,155,0,28,0,7,0,145,0,161,0,253,0,29,0,157,0,0,0,0,0,151,0,97,0,168,0,142,0,46,0,32,0,171,0,101,0,0,0,9,0,59,0,106,0,208,0,222,0,0,0,24,0,0,0,0,0,53,0,218,0,0,0,0,0,0,0,235,0,0,0,141,0,107,0,128,0,0,0,35,0,100,0,214,0,39,0,40,0,226,0,0,0,64,0,0,0,0,0,220,0,147,0,108,0,175,0,0,0,30,0,164,0,0,0,125,0,0,0,96,0,156,0,0,0,60,0,107,0,221,0,0,0,199,0,189,0,36,0,253,0,140,0,24,0,0,0,226,0,57,0,0,0,215,0,213,0,0,0,218,0,135,0,0,0,17,0,0,0,204,0,211,0,189,0,184,0,212,0,101,0,58,0,10,0,199,0,0,0,247,0,191,0,194,0,31,0,32,0,0,0,48,0,107,0,242,0,33,0,0,0,34,0,172,0,0,0,236,0,146,0,105,0,175,0,32,0,127,0,97,0,236,0,149,0,141,0,164,0,112,0,184,0,203,0,100,0,197,0,204,0,14,0,118,0,7,0,194,0,5,0,141,0,124,0,39,0,235,0,105,0,142,0,154,0,0,0,21,0,9,0,0,0,250,0,238,0,0,0,0,0,169,0,206,0,73,0,0,0,222,0,120,0,228,0,75,0,0,0,2,0,190,0,184,0,35,0,191,0,187,0,82,0,36,0,199,0,142,0,177,0,35,0,139,0,183,0,44,0,168,0,0,0,134,0,254,0,93,0,125,0,137,0,161,0,27,0,204,0,13,0,86,0,107,0,15,0,249,0,69,0,10,0,217,0,0,0,77,0,198,0,62,0,98,0,126,0,165,0,23,0,0,0,84,0,193,0,20,0,0,0,65,0,219,0,92,0,49,0,127,0,124,0,219,0,157,0,89,0,0,0,69,0,42,0,157,0,161,0,189,0,115,0,143,0,226,0,170,0,0,0,113,0,0,0,81,0,123,0,118,0,109,0,33,0,28,0,0,0,0,0,174,0,0,0,157,0,104,0,38,0,38,0,109,0,0,0,0,0,148,0,0,0,126,0,76,0,205,0,217,0,76,0,221,0,106,0,112,0,172,0,233,0,201,0,107,0,171,0,255,0,121,0,0,0,136,0,152,0,152,0,72,0,0,0,252,0,139,0,1,0,0,0,171,0,0,0,250,0,207,0,151,0,96,0,118,0,0,0,253,0,47,0,103,0);
signal scenario_full  : scenario_type := (0,0,167,31,201,31,51,31,37,31,176,31,47,31,128,31,143,31,143,30,143,29,212,31,212,30,69,31,15,31,135,31,135,30,136,31,111,31,73,31,199,31,89,31,89,30,89,29,89,28,74,31,92,31,18,31,18,30,18,29,18,28,95,31,95,30,91,31,168,31,206,31,76,31,250,31,231,31,230,31,222,31,222,30,222,29,102,31,202,31,150,31,150,30,104,31,35,31,139,31,98,31,199,31,111,31,251,31,249,31,249,30,249,29,37,31,37,30,42,31,197,31,172,31,13,31,205,31,180,31,191,31,162,31,113,31,83,31,83,30,217,31,96,31,69,31,69,30,131,31,225,31,11,31,91,31,202,31,10,31,10,30,10,29,77,31,68,31,45,31,179,31,55,31,194,31,24,31,24,30,7,31,110,31,110,30,110,29,110,28,159,31,191,31,191,30,18,31,18,30,18,29,18,28,141,31,254,31,254,30,215,31,220,31,70,31,141,31,141,30,17,31,115,31,191,31,83,31,223,31,198,31,198,30,225,31,5,31,93,31,93,30,231,31,157,31,181,31,30,31,108,31,108,30,174,31,131,31,131,31,131,30,162,31,67,31,60,31,57,31,57,30,57,29,135,31,249,31,40,31,197,31,102,31,39,31,222,31,222,30,90,31,90,30,179,31,61,31,230,31,70,31,1,31,64,31,214,31,111,31,3,31,21,31,36,31,132,31,132,31,132,30,14,31,14,30,60,31,213,31,6,31,63,31,90,31,232,31,242,31,201,31,201,30,212,31,66,31,91,31,26,31,169,31,114,31,105,31,250,31,138,31,138,30,145,31,145,30,251,31,251,30,31,31,98,31,87,31,87,30,193,31,137,31,137,30,41,31,224,31,224,30,25,31,220,31,226,31,250,31,157,31,56,31,56,30,32,31,82,31,82,30,169,31,163,31,120,31,115,31,16,31,16,30,188,31,159,31,65,31,169,31,169,30,19,31,78,31,160,31,158,31,92,31,162,31,228,31,136,31,252,31,157,31,243,31,2,31,78,31,134,31,248,31,69,31,69,30,84,31,223,31,69,31,69,30,179,31,221,31,221,30,221,29,199,31,216,31,67,31,67,30,161,31,68,31,68,30,177,31,62,31,62,30,228,31,70,31,138,31,15,31,15,30,97,31,53,31,62,31,165,31,44,31,106,31,121,31,160,31,95,31,116,31,10,31,156,31,183,31,95,31,235,31,235,30,135,31,135,30,100,31,211,31,246,31,34,31,60,31,45,31,226,31,86,31,211,31,220,31,11,31,11,30,65,31,99,31,229,31,229,30,229,29,251,31,251,30,59,31,127,31,66,31,155,31,28,31,7,31,145,31,161,31,253,31,29,31,157,31,157,30,157,29,151,31,97,31,168,31,142,31,46,31,32,31,171,31,101,31,101,30,9,31,59,31,106,31,208,31,222,31,222,30,24,31,24,30,24,29,53,31,218,31,218,30,218,29,218,28,235,31,235,30,141,31,107,31,128,31,128,30,35,31,100,31,214,31,39,31,40,31,226,31,226,30,64,31,64,30,64,29,220,31,147,31,108,31,175,31,175,30,30,31,164,31,164,30,125,31,125,30,96,31,156,31,156,30,60,31,107,31,221,31,221,30,199,31,189,31,36,31,253,31,140,31,24,31,24,30,226,31,57,31,57,30,215,31,213,31,213,30,218,31,135,31,135,30,17,31,17,30,204,31,211,31,189,31,184,31,212,31,101,31,58,31,10,31,199,31,199,30,247,31,191,31,194,31,31,31,32,31,32,30,48,31,107,31,242,31,33,31,33,30,34,31,172,31,172,30,236,31,146,31,105,31,175,31,32,31,127,31,97,31,236,31,149,31,141,31,164,31,112,31,184,31,203,31,100,31,197,31,204,31,14,31,118,31,7,31,194,31,5,31,141,31,124,31,39,31,235,31,105,31,142,31,154,31,154,30,21,31,9,31,9,30,250,31,238,31,238,30,238,29,169,31,206,31,73,31,73,30,222,31,120,31,228,31,75,31,75,30,2,31,190,31,184,31,35,31,191,31,187,31,82,31,36,31,199,31,142,31,177,31,35,31,139,31,183,31,44,31,168,31,168,30,134,31,254,31,93,31,125,31,137,31,161,31,27,31,204,31,13,31,86,31,107,31,15,31,249,31,69,31,10,31,217,31,217,30,77,31,198,31,62,31,98,31,126,31,165,31,23,31,23,30,84,31,193,31,20,31,20,30,65,31,219,31,92,31,49,31,127,31,124,31,219,31,157,31,89,31,89,30,69,31,42,31,157,31,161,31,189,31,115,31,143,31,226,31,170,31,170,30,113,31,113,30,81,31,123,31,118,31,109,31,33,31,28,31,28,30,28,29,174,31,174,30,157,31,104,31,38,31,38,31,109,31,109,30,109,29,148,31,148,30,126,31,76,31,205,31,217,31,76,31,221,31,106,31,112,31,172,31,233,31,201,31,107,31,171,31,255,31,121,31,121,30,136,31,152,31,152,31,72,31,72,30,252,31,139,31,1,31,1,30,171,31,171,30,250,31,207,31,151,31,96,31,118,31,118,30,253,31,47,31,103,31);

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
