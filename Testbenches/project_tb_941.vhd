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

constant SCENARIO_LENGTH : integer := 588;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (243,0,130,0,160,0,129,0,146,0,153,0,243,0,174,0,181,0,184,0,203,0,158,0,0,0,116,0,128,0,3,0,101,0,228,0,240,0,0,0,0,0,150,0,59,0,35,0,239,0,144,0,0,0,253,0,124,0,249,0,0,0,24,0,0,0,0,0,142,0,129,0,17,0,244,0,16,0,97,0,29,0,41,0,35,0,0,0,0,0,179,0,149,0,128,0,148,0,107,0,116,0,0,0,0,0,27,0,253,0,0,0,0,0,217,0,34,0,0,0,228,0,127,0,157,0,35,0,34,0,47,0,85,0,0,0,2,0,207,0,172,0,207,0,224,0,29,0,23,0,81,0,66,0,162,0,123,0,183,0,105,0,14,0,7,0,31,0,0,0,201,0,203,0,46,0,194,0,56,0,84,0,0,0,151,0,132,0,208,0,178,0,97,0,218,0,231,0,164,0,96,0,222,0,0,0,150,0,82,0,0,0,6,0,141,0,0,0,0,0,120,0,116,0,242,0,46,0,204,0,101,0,121,0,214,0,223,0,92,0,176,0,70,0,0,0,98,0,143,0,128,0,91,0,0,0,0,0,205,0,0,0,0,0,55,0,51,0,0,0,0,0,200,0,0,0,23,0,225,0,65,0,147,0,22,0,117,0,0,0,208,0,100,0,104,0,148,0,181,0,174,0,251,0,77,0,173,0,86,0,0,0,0,0,216,0,28,0,149,0,42,0,202,0,87,0,244,0,230,0,42,0,0,0,33,0,92,0,0,0,57,0,148,0,0,0,124,0,27,0,245,0,177,0,215,0,191,0,109,0,148,0,0,0,0,0,0,0,139,0,186,0,150,0,149,0,0,0,141,0,38,0,193,0,71,0,55,0,17,0,0,0,14,0,97,0,180,0,236,0,127,0,0,0,20,0,245,0,47,0,240,0,193,0,173,0,250,0,239,0,56,0,62,0,0,0,2,0,100,0,48,0,19,0,122,0,0,0,0,0,183,0,0,0,149,0,0,0,160,0,217,0,0,0,99,0,0,0,58,0,44,0,209,0,7,0,8,0,41,0,135,0,87,0,164,0,201,0,196,0,241,0,36,0,95,0,91,0,0,0,249,0,0,0,22,0,139,0,0,0,103,0,0,0,80,0,0,0,171,0,153,0,107,0,196,0,220,0,88,0,131,0,0,0,178,0,0,0,240,0,153,0,207,0,0,0,64,0,170,0,172,0,231,0,154,0,0,0,102,0,87,0,0,0,5,0,0,0,175,0,50,0,0,0,25,0,108,0,157,0,160,0,134,0,46,0,82,0,102,0,238,0,0,0,0,0,206,0,126,0,143,0,30,0,77,0,58,0,92,0,104,0,37,0,229,0,44,0,204,0,199,0,118,0,82,0,0,0,18,0,206,0,201,0,0,0,140,0,235,0,245,0,0,0,82,0,53,0,0,0,90,0,71,0,211,0,250,0,31,0,0,0,0,0,113,0,41,0,237,0,25,0,0,0,108,0,31,0,81,0,35,0,102,0,211,0,131,0,98,0,55,0,33,0,180,0,0,0,86,0,0,0,111,0,46,0,0,0,161,0,72,0,175,0,17,0,152,0,0,0,187,0,169,0,73,0,239,0,76,0,183,0,231,0,242,0,253,0,46,0,0,0,16,0,0,0,28,0,89,0,171,0,193,0,182,0,178,0,37,0,0,0,0,0,73,0,190,0,54,0,12,0,40,0,32,0,187,0,157,0,144,0,0,0,111,0,234,0,223,0,72,0,207,0,251,0,0,0,152,0,32,0,205,0,83,0,120,0,236,0,222,0,245,0,29,0,0,0,104,0,47,0,92,0,99,0,162,0,96,0,101,0,123,0,0,0,0,0,112,0,134,0,0,0,0,0,141,0,102,0,23,0,212,0,159,0,65,0,95,0,169,0,124,0,0,0,188,0,0,0,99,0,234,0,106,0,0,0,0,0,0,0,247,0,158,0,0,0,94,0,0,0,0,0,117,0,0,0,90,0,19,0,44,0,127,0,113,0,0,0,61,0,32,0,93,0,74,0,212,0,67,0,0,0,166,0,0,0,69,0,0,0,28,0,120,0,188,0,160,0,0,0,131,0,177,0,0,0,0,0,0,0,37,0,41,0,80,0,65,0,218,0,25,0,236,0,148,0,0,0,0,0,98,0,63,0,222,0,149,0,197,0,150,0,48,0,134,0,127,0,236,0,0,0,104,0,196,0,0,0,0,0,75,0,48,0,72,0,215,0,186,0,177,0,172,0,0,0,6,0,46,0,0,0,28,0,129,0,245,0,171,0,0,0,19,0,0,0,45,0,0,0,47,0,140,0,125,0,199,0,0,0,105,0,24,0,124,0,0,0,222,0,218,0,0,0,251,0,190,0,86,0,0,0,151,0,14,0,201,0,144,0,89,0,153,0,0,0,105,0,96,0,70,0,178,0,15,0,36,0,126,0,203,0,72,0,43,0,101,0,103,0,0,0,139,0,118,0,139,0,152,0,0,0,168,0,60,0,163,0,79,0,188,0,129,0,0,0,0,0,170,0,194,0,59,0,8,0,248,0,85,0,55,0,225,0,66,0,0,0,160,0,159,0,73,0,0,0,125,0,0,0,216,0,107,0,176,0,133,0,199,0,99,0,234,0);
signal scenario_full  : scenario_type := (243,31,130,31,160,31,129,31,146,31,153,31,243,31,174,31,181,31,184,31,203,31,158,31,158,30,116,31,128,31,3,31,101,31,228,31,240,31,240,30,240,29,150,31,59,31,35,31,239,31,144,31,144,30,253,31,124,31,249,31,249,30,24,31,24,30,24,29,142,31,129,31,17,31,244,31,16,31,97,31,29,31,41,31,35,31,35,30,35,29,179,31,149,31,128,31,148,31,107,31,116,31,116,30,116,29,27,31,253,31,253,30,253,29,217,31,34,31,34,30,228,31,127,31,157,31,35,31,34,31,47,31,85,31,85,30,2,31,207,31,172,31,207,31,224,31,29,31,23,31,81,31,66,31,162,31,123,31,183,31,105,31,14,31,7,31,31,31,31,30,201,31,203,31,46,31,194,31,56,31,84,31,84,30,151,31,132,31,208,31,178,31,97,31,218,31,231,31,164,31,96,31,222,31,222,30,150,31,82,31,82,30,6,31,141,31,141,30,141,29,120,31,116,31,242,31,46,31,204,31,101,31,121,31,214,31,223,31,92,31,176,31,70,31,70,30,98,31,143,31,128,31,91,31,91,30,91,29,205,31,205,30,205,29,55,31,51,31,51,30,51,29,200,31,200,30,23,31,225,31,65,31,147,31,22,31,117,31,117,30,208,31,100,31,104,31,148,31,181,31,174,31,251,31,77,31,173,31,86,31,86,30,86,29,216,31,28,31,149,31,42,31,202,31,87,31,244,31,230,31,42,31,42,30,33,31,92,31,92,30,57,31,148,31,148,30,124,31,27,31,245,31,177,31,215,31,191,31,109,31,148,31,148,30,148,29,148,28,139,31,186,31,150,31,149,31,149,30,141,31,38,31,193,31,71,31,55,31,17,31,17,30,14,31,97,31,180,31,236,31,127,31,127,30,20,31,245,31,47,31,240,31,193,31,173,31,250,31,239,31,56,31,62,31,62,30,2,31,100,31,48,31,19,31,122,31,122,30,122,29,183,31,183,30,149,31,149,30,160,31,217,31,217,30,99,31,99,30,58,31,44,31,209,31,7,31,8,31,41,31,135,31,87,31,164,31,201,31,196,31,241,31,36,31,95,31,91,31,91,30,249,31,249,30,22,31,139,31,139,30,103,31,103,30,80,31,80,30,171,31,153,31,107,31,196,31,220,31,88,31,131,31,131,30,178,31,178,30,240,31,153,31,207,31,207,30,64,31,170,31,172,31,231,31,154,31,154,30,102,31,87,31,87,30,5,31,5,30,175,31,50,31,50,30,25,31,108,31,157,31,160,31,134,31,46,31,82,31,102,31,238,31,238,30,238,29,206,31,126,31,143,31,30,31,77,31,58,31,92,31,104,31,37,31,229,31,44,31,204,31,199,31,118,31,82,31,82,30,18,31,206,31,201,31,201,30,140,31,235,31,245,31,245,30,82,31,53,31,53,30,90,31,71,31,211,31,250,31,31,31,31,30,31,29,113,31,41,31,237,31,25,31,25,30,108,31,31,31,81,31,35,31,102,31,211,31,131,31,98,31,55,31,33,31,180,31,180,30,86,31,86,30,111,31,46,31,46,30,161,31,72,31,175,31,17,31,152,31,152,30,187,31,169,31,73,31,239,31,76,31,183,31,231,31,242,31,253,31,46,31,46,30,16,31,16,30,28,31,89,31,171,31,193,31,182,31,178,31,37,31,37,30,37,29,73,31,190,31,54,31,12,31,40,31,32,31,187,31,157,31,144,31,144,30,111,31,234,31,223,31,72,31,207,31,251,31,251,30,152,31,32,31,205,31,83,31,120,31,236,31,222,31,245,31,29,31,29,30,104,31,47,31,92,31,99,31,162,31,96,31,101,31,123,31,123,30,123,29,112,31,134,31,134,30,134,29,141,31,102,31,23,31,212,31,159,31,65,31,95,31,169,31,124,31,124,30,188,31,188,30,99,31,234,31,106,31,106,30,106,29,106,28,247,31,158,31,158,30,94,31,94,30,94,29,117,31,117,30,90,31,19,31,44,31,127,31,113,31,113,30,61,31,32,31,93,31,74,31,212,31,67,31,67,30,166,31,166,30,69,31,69,30,28,31,120,31,188,31,160,31,160,30,131,31,177,31,177,30,177,29,177,28,37,31,41,31,80,31,65,31,218,31,25,31,236,31,148,31,148,30,148,29,98,31,63,31,222,31,149,31,197,31,150,31,48,31,134,31,127,31,236,31,236,30,104,31,196,31,196,30,196,29,75,31,48,31,72,31,215,31,186,31,177,31,172,31,172,30,6,31,46,31,46,30,28,31,129,31,245,31,171,31,171,30,19,31,19,30,45,31,45,30,47,31,140,31,125,31,199,31,199,30,105,31,24,31,124,31,124,30,222,31,218,31,218,30,251,31,190,31,86,31,86,30,151,31,14,31,201,31,144,31,89,31,153,31,153,30,105,31,96,31,70,31,178,31,15,31,36,31,126,31,203,31,72,31,43,31,101,31,103,31,103,30,139,31,118,31,139,31,152,31,152,30,168,31,60,31,163,31,79,31,188,31,129,31,129,30,129,29,170,31,194,31,59,31,8,31,248,31,85,31,55,31,225,31,66,31,66,30,160,31,159,31,73,31,73,30,125,31,125,30,216,31,107,31,176,31,133,31,199,31,99,31,234,31);

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
