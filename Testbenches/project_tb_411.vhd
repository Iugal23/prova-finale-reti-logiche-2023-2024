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

constant SCENARIO_LENGTH : integer := 426;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (43,0,0,0,207,0,103,0,0,0,238,0,106,0,142,0,24,0,70,0,0,0,0,0,0,0,224,0,0,0,31,0,153,0,34,0,255,0,240,0,176,0,218,0,61,0,0,0,0,0,249,0,10,0,2,0,236,0,33,0,0,0,0,0,89,0,36,0,140,0,137,0,91,0,0,0,245,0,28,0,85,0,0,0,110,0,161,0,32,0,0,0,31,0,102,0,216,0,92,0,85,0,33,0,238,0,220,0,100,0,136,0,44,0,248,0,85,0,100,0,0,0,116,0,201,0,0,0,67,0,68,0,190,0,90,0,85,0,10,0,55,0,243,0,40,0,0,0,117,0,60,0,89,0,162,0,56,0,0,0,165,0,127,0,15,0,0,0,87,0,17,0,0,0,229,0,45,0,3,0,239,0,160,0,246,0,125,0,17,0,0,0,246,0,97,0,254,0,51,0,66,0,198,0,0,0,53,0,130,0,169,0,15,0,0,0,47,0,0,0,179,0,94,0,107,0,249,0,1,0,49,0,196,0,0,0,110,0,173,0,0,0,182,0,59,0,167,0,141,0,148,0,93,0,162,0,151,0,99,0,207,0,35,0,196,0,50,0,3,0,247,0,254,0,0,0,230,0,0,0,233,0,215,0,171,0,184,0,36,0,144,0,0,0,183,0,32,0,213,0,3,0,235,0,22,0,0,0,108,0,0,0,0,0,35,0,183,0,67,0,253,0,0,0,0,0,197,0,134,0,95,0,0,0,17,0,117,0,58,0,175,0,0,0,199,0,27,0,0,0,166,0,255,0,29,0,142,0,171,0,133,0,0,0,56,0,44,0,0,0,157,0,136,0,196,0,121,0,125,0,22,0,130,0,112,0,22,0,0,0,108,0,93,0,39,0,0,0,47,0,207,0,14,0,47,0,78,0,101,0,167,0,0,0,0,0,214,0,57,0,224,0,159,0,32,0,0,0,129,0,0,0,231,0,0,0,250,0,243,0,218,0,183,0,94,0,38,0,220,0,0,0,115,0,44,0,113,0,50,0,215,0,233,0,81,0,90,0,142,0,217,0,169,0,112,0,168,0,236,0,57,0,87,0,81,0,141,0,0,0,0,0,164,0,181,0,171,0,9,0,203,0,87,0,0,0,171,0,187,0,0,0,49,0,0,0,236,0,141,0,131,0,0,0,38,0,0,0,181,0,255,0,0,0,193,0,29,0,0,0,59,0,125,0,179,0,251,0,0,0,36,0,48,0,241,0,33,0,201,0,135,0,134,0,128,0,144,0,0,0,94,0,43,0,126,0,43,0,246,0,132,0,182,0,0,0,177,0,183,0,125,0,241,0,97,0,143,0,67,0,24,0,76,0,75,0,209,0,0,0,149,0,239,0,15,0,163,0,0,0,45,0,42,0,172,0,254,0,243,0,123,0,59,0,0,0,171,0,189,0,176,0,0,0,130,0,159,0,254,0,169,0,45,0,0,0,186,0,164,0,238,0,205,0,18,0,21,0,153,0,83,0,143,0,0,0,0,0,233,0,220,0,52,0,246,0,192,0,80,0,218,0,0,0,138,0,107,0,132,0,103,0,128,0,64,0,158,0,190,0,39,0,189,0,144,0,0,0,146,0,24,0,234,0,182,0,233,0,165,0,228,0,105,0,23,0,55,0,92,0,43,0,249,0,48,0,202,0,0,0,169,0,226,0,41,0,68,0,228,0,56,0,224,0,64,0,113,0,60,0,222,0,45,0,109,0,178,0,79,0,64,0,169,0,221,0,85,0,129,0,237,0,193,0,230,0,135,0,240,0,174,0,96,0,0,0,90,0,223,0,175,0,0,0,23,0,66,0,85,0,45,0,152,0,0,0,55,0,144,0,0,0,199,0,0,0,233,0,47,0,0,0,50,0,114,0,240,0,234,0,215,0);
signal scenario_full  : scenario_type := (43,31,43,30,207,31,103,31,103,30,238,31,106,31,142,31,24,31,70,31,70,30,70,29,70,28,224,31,224,30,31,31,153,31,34,31,255,31,240,31,176,31,218,31,61,31,61,30,61,29,249,31,10,31,2,31,236,31,33,31,33,30,33,29,89,31,36,31,140,31,137,31,91,31,91,30,245,31,28,31,85,31,85,30,110,31,161,31,32,31,32,30,31,31,102,31,216,31,92,31,85,31,33,31,238,31,220,31,100,31,136,31,44,31,248,31,85,31,100,31,100,30,116,31,201,31,201,30,67,31,68,31,190,31,90,31,85,31,10,31,55,31,243,31,40,31,40,30,117,31,60,31,89,31,162,31,56,31,56,30,165,31,127,31,15,31,15,30,87,31,17,31,17,30,229,31,45,31,3,31,239,31,160,31,246,31,125,31,17,31,17,30,246,31,97,31,254,31,51,31,66,31,198,31,198,30,53,31,130,31,169,31,15,31,15,30,47,31,47,30,179,31,94,31,107,31,249,31,1,31,49,31,196,31,196,30,110,31,173,31,173,30,182,31,59,31,167,31,141,31,148,31,93,31,162,31,151,31,99,31,207,31,35,31,196,31,50,31,3,31,247,31,254,31,254,30,230,31,230,30,233,31,215,31,171,31,184,31,36,31,144,31,144,30,183,31,32,31,213,31,3,31,235,31,22,31,22,30,108,31,108,30,108,29,35,31,183,31,67,31,253,31,253,30,253,29,197,31,134,31,95,31,95,30,17,31,117,31,58,31,175,31,175,30,199,31,27,31,27,30,166,31,255,31,29,31,142,31,171,31,133,31,133,30,56,31,44,31,44,30,157,31,136,31,196,31,121,31,125,31,22,31,130,31,112,31,22,31,22,30,108,31,93,31,39,31,39,30,47,31,207,31,14,31,47,31,78,31,101,31,167,31,167,30,167,29,214,31,57,31,224,31,159,31,32,31,32,30,129,31,129,30,231,31,231,30,250,31,243,31,218,31,183,31,94,31,38,31,220,31,220,30,115,31,44,31,113,31,50,31,215,31,233,31,81,31,90,31,142,31,217,31,169,31,112,31,168,31,236,31,57,31,87,31,81,31,141,31,141,30,141,29,164,31,181,31,171,31,9,31,203,31,87,31,87,30,171,31,187,31,187,30,49,31,49,30,236,31,141,31,131,31,131,30,38,31,38,30,181,31,255,31,255,30,193,31,29,31,29,30,59,31,125,31,179,31,251,31,251,30,36,31,48,31,241,31,33,31,201,31,135,31,134,31,128,31,144,31,144,30,94,31,43,31,126,31,43,31,246,31,132,31,182,31,182,30,177,31,183,31,125,31,241,31,97,31,143,31,67,31,24,31,76,31,75,31,209,31,209,30,149,31,239,31,15,31,163,31,163,30,45,31,42,31,172,31,254,31,243,31,123,31,59,31,59,30,171,31,189,31,176,31,176,30,130,31,159,31,254,31,169,31,45,31,45,30,186,31,164,31,238,31,205,31,18,31,21,31,153,31,83,31,143,31,143,30,143,29,233,31,220,31,52,31,246,31,192,31,80,31,218,31,218,30,138,31,107,31,132,31,103,31,128,31,64,31,158,31,190,31,39,31,189,31,144,31,144,30,146,31,24,31,234,31,182,31,233,31,165,31,228,31,105,31,23,31,55,31,92,31,43,31,249,31,48,31,202,31,202,30,169,31,226,31,41,31,68,31,228,31,56,31,224,31,64,31,113,31,60,31,222,31,45,31,109,31,178,31,79,31,64,31,169,31,221,31,85,31,129,31,237,31,193,31,230,31,135,31,240,31,174,31,96,31,96,30,90,31,223,31,175,31,175,30,23,31,66,31,85,31,45,31,152,31,152,30,55,31,144,31,144,30,199,31,199,30,233,31,47,31,47,30,50,31,114,31,240,31,234,31,215,31);

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
