-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_475 is
end project_tb_475;

architecture project_tb_arch_475 of project_tb_475 is
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

constant SCENARIO_LENGTH : integer := 552;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,44,0,95,0,0,0,38,0,227,0,64,0,76,0,218,0,190,0,76,0,161,0,250,0,208,0,132,0,133,0,71,0,55,0,85,0,20,0,146,0,116,0,123,0,0,0,176,0,220,0,188,0,0,0,235,0,215,0,67,0,27,0,140,0,226,0,235,0,160,0,0,0,9,0,0,0,58,0,0,0,194,0,118,0,116,0,0,0,163,0,14,0,177,0,63,0,175,0,245,0,187,0,193,0,125,0,143,0,101,0,235,0,49,0,29,0,166,0,133,0,246,0,162,0,197,0,0,0,0,0,202,0,160,0,147,0,0,0,205,0,12,0,29,0,0,0,63,0,0,0,38,0,18,0,139,0,0,0,83,0,244,0,0,0,40,0,249,0,0,0,114,0,205,0,91,0,117,0,154,0,58,0,119,0,178,0,134,0,216,0,169,0,115,0,212,0,52,0,45,0,191,0,117,0,225,0,77,0,0,0,182,0,133,0,102,0,172,0,179,0,15,0,17,0,247,0,200,0,0,0,94,0,0,0,86,0,77,0,18,0,149,0,121,0,0,0,140,0,141,0,0,0,87,0,133,0,150,0,211,0,24,0,142,0,171,0,212,0,149,0,86,0,98,0,54,0,205,0,170,0,25,0,0,0,54,0,234,0,229,0,44,0,121,0,0,0,0,0,191,0,0,0,177,0,0,0,136,0,140,0,0,0,33,0,71,0,203,0,0,0,216,0,254,0,18,0,53,0,228,0,203,0,234,0,192,0,151,0,0,0,140,0,173,0,0,0,214,0,53,0,0,0,113,0,0,0,0,0,0,0,62,0,76,0,247,0,229,0,79,0,170,0,193,0,83,0,242,0,0,0,173,0,16,0,8,0,102,0,253,0,243,0,0,0,57,0,220,0,78,0,185,0,10,0,123,0,194,0,129,0,221,0,0,0,24,0,0,0,91,0,0,0,229,0,129,0,221,0,248,0,102,0,115,0,0,0,0,0,10,0,0,0,148,0,146,0,250,0,192,0,169,0,171,0,31,0,107,0,0,0,202,0,0,0,73,0,126,0,141,0,176,0,250,0,0,0,234,0,0,0,149,0,206,0,103,0,0,0,226,0,29,0,51,0,71,0,192,0,15,0,23,0,117,0,117,0,106,0,32,0,176,0,0,0,248,0,95,0,171,0,186,0,117,0,32,0,214,0,5,0,9,0,232,0,143,0,55,0,132,0,33,0,218,0,0,0,54,0,5,0,0,0,0,0,92,0,238,0,249,0,63,0,231,0,70,0,0,0,164,0,109,0,62,0,20,0,97,0,86,0,178,0,39,0,107,0,154,0,186,0,72,0,0,0,15,0,97,0,197,0,224,0,217,0,100,0,0,0,87,0,251,0,87,0,50,0,3,0,213,0,0,0,104,0,39,0,0,0,78,0,0,0,71,0,55,0,250,0,103,0,24,0,166,0,66,0,206,0,167,0,0,0,84,0,55,0,88,0,0,0,127,0,103,0,96,0,219,0,126,0,163,0,101,0,71,0,20,0,164,0,231,0,57,0,3,0,171,0,196,0,165,0,73,0,138,0,0,0,0,0,169,0,0,0,54,0,247,0,27,0,138,0,197,0,240,0,0,0,0,0,40,0,64,0,23,0,74,0,173,0,0,0,66,0,220,0,225,0,24,0,0,0,132,0,165,0,194,0,0,0,151,0,158,0,0,0,0,0,145,0,202,0,0,0,0,0,126,0,222,0,230,0,0,0,82,0,76,0,0,0,143,0,0,0,67,0,95,0,0,0,110,0,181,0,0,0,18,0,206,0,39,0,147,0,202,0,159,0,0,0,118,0,0,0,65,0,104,0,236,0,0,0,200,0,5,0,153,0,249,0,16,0,80,0,223,0,0,0,43,0,30,0,50,0,120,0,0,0,83,0,144,0,88,0,86,0,166,0,0,0,0,0,36,0,0,0,116,0,141,0,190,0,38,0,184,0,179,0,246,0,178,0,94,0,26,0,176,0,0,0,221,0,194,0,133,0,0,0,91,0,145,0,56,0,0,0,100,0,0,0,0,0,0,0,167,0,117,0,140,0,212,0,183,0,85,0,232,0,185,0,110,0,0,0,146,0,217,0,0,0,12,0,42,0,0,0,0,0,138,0,164,0,23,0,48,0,220,0,87,0,106,0,228,0,133,0,227,0,231,0,223,0,245,0,83,0,181,0,199,0,46,0,107,0,0,0,0,0,237,0,19,0,12,0,114,0,124,0,54,0,140,0,84,0,199,0,12,0,142,0,89,0,234,0,0,0,106,0,90,0,140,0,0,0,93,0,0,0,119,0,101,0,110,0,122,0,183,0,197,0,157,0,159,0,189,0,11,0,3,0,42,0,165,0,200,0,63,0,98,0,183,0,0,0,251,0,0,0,123,0,75,0,0,0,48,0,31,0,84,0,222,0,61,0,0,0,0,0,0,0,0,0,203,0,75,0,107,0,220,0);
signal scenario_full  : scenario_type := (0,0,0,0,44,31,95,31,95,30,38,31,227,31,64,31,76,31,218,31,190,31,76,31,161,31,250,31,208,31,132,31,133,31,71,31,55,31,85,31,20,31,146,31,116,31,123,31,123,30,176,31,220,31,188,31,188,30,235,31,215,31,67,31,27,31,140,31,226,31,235,31,160,31,160,30,9,31,9,30,58,31,58,30,194,31,118,31,116,31,116,30,163,31,14,31,177,31,63,31,175,31,245,31,187,31,193,31,125,31,143,31,101,31,235,31,49,31,29,31,166,31,133,31,246,31,162,31,197,31,197,30,197,29,202,31,160,31,147,31,147,30,205,31,12,31,29,31,29,30,63,31,63,30,38,31,18,31,139,31,139,30,83,31,244,31,244,30,40,31,249,31,249,30,114,31,205,31,91,31,117,31,154,31,58,31,119,31,178,31,134,31,216,31,169,31,115,31,212,31,52,31,45,31,191,31,117,31,225,31,77,31,77,30,182,31,133,31,102,31,172,31,179,31,15,31,17,31,247,31,200,31,200,30,94,31,94,30,86,31,77,31,18,31,149,31,121,31,121,30,140,31,141,31,141,30,87,31,133,31,150,31,211,31,24,31,142,31,171,31,212,31,149,31,86,31,98,31,54,31,205,31,170,31,25,31,25,30,54,31,234,31,229,31,44,31,121,31,121,30,121,29,191,31,191,30,177,31,177,30,136,31,140,31,140,30,33,31,71,31,203,31,203,30,216,31,254,31,18,31,53,31,228,31,203,31,234,31,192,31,151,31,151,30,140,31,173,31,173,30,214,31,53,31,53,30,113,31,113,30,113,29,113,28,62,31,76,31,247,31,229,31,79,31,170,31,193,31,83,31,242,31,242,30,173,31,16,31,8,31,102,31,253,31,243,31,243,30,57,31,220,31,78,31,185,31,10,31,123,31,194,31,129,31,221,31,221,30,24,31,24,30,91,31,91,30,229,31,129,31,221,31,248,31,102,31,115,31,115,30,115,29,10,31,10,30,148,31,146,31,250,31,192,31,169,31,171,31,31,31,107,31,107,30,202,31,202,30,73,31,126,31,141,31,176,31,250,31,250,30,234,31,234,30,149,31,206,31,103,31,103,30,226,31,29,31,51,31,71,31,192,31,15,31,23,31,117,31,117,31,106,31,32,31,176,31,176,30,248,31,95,31,171,31,186,31,117,31,32,31,214,31,5,31,9,31,232,31,143,31,55,31,132,31,33,31,218,31,218,30,54,31,5,31,5,30,5,29,92,31,238,31,249,31,63,31,231,31,70,31,70,30,164,31,109,31,62,31,20,31,97,31,86,31,178,31,39,31,107,31,154,31,186,31,72,31,72,30,15,31,97,31,197,31,224,31,217,31,100,31,100,30,87,31,251,31,87,31,50,31,3,31,213,31,213,30,104,31,39,31,39,30,78,31,78,30,71,31,55,31,250,31,103,31,24,31,166,31,66,31,206,31,167,31,167,30,84,31,55,31,88,31,88,30,127,31,103,31,96,31,219,31,126,31,163,31,101,31,71,31,20,31,164,31,231,31,57,31,3,31,171,31,196,31,165,31,73,31,138,31,138,30,138,29,169,31,169,30,54,31,247,31,27,31,138,31,197,31,240,31,240,30,240,29,40,31,64,31,23,31,74,31,173,31,173,30,66,31,220,31,225,31,24,31,24,30,132,31,165,31,194,31,194,30,151,31,158,31,158,30,158,29,145,31,202,31,202,30,202,29,126,31,222,31,230,31,230,30,82,31,76,31,76,30,143,31,143,30,67,31,95,31,95,30,110,31,181,31,181,30,18,31,206,31,39,31,147,31,202,31,159,31,159,30,118,31,118,30,65,31,104,31,236,31,236,30,200,31,5,31,153,31,249,31,16,31,80,31,223,31,223,30,43,31,30,31,50,31,120,31,120,30,83,31,144,31,88,31,86,31,166,31,166,30,166,29,36,31,36,30,116,31,141,31,190,31,38,31,184,31,179,31,246,31,178,31,94,31,26,31,176,31,176,30,221,31,194,31,133,31,133,30,91,31,145,31,56,31,56,30,100,31,100,30,100,29,100,28,167,31,117,31,140,31,212,31,183,31,85,31,232,31,185,31,110,31,110,30,146,31,217,31,217,30,12,31,42,31,42,30,42,29,138,31,164,31,23,31,48,31,220,31,87,31,106,31,228,31,133,31,227,31,231,31,223,31,245,31,83,31,181,31,199,31,46,31,107,31,107,30,107,29,237,31,19,31,12,31,114,31,124,31,54,31,140,31,84,31,199,31,12,31,142,31,89,31,234,31,234,30,106,31,90,31,140,31,140,30,93,31,93,30,119,31,101,31,110,31,122,31,183,31,197,31,157,31,159,31,189,31,11,31,3,31,42,31,165,31,200,31,63,31,98,31,183,31,183,30,251,31,251,30,123,31,75,31,75,30,48,31,31,31,84,31,222,31,61,31,61,30,61,29,61,28,61,27,203,31,75,31,107,31,220,31);

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
