-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_118 is
end project_tb_118;

architecture project_tb_arch_118 of project_tb_118 is
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

constant SCENARIO_LENGTH : integer := 233;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (151,0,0,0,160,0,1,0,0,0,0,0,43,0,0,0,183,0,22,0,58,0,128,0,172,0,175,0,0,0,151,0,105,0,159,0,230,0,0,0,174,0,0,0,164,0,53,0,220,0,180,0,0,0,244,0,136,0,198,0,149,0,0,0,56,0,99,0,222,0,239,0,100,0,15,0,164,0,73,0,148,0,117,0,107,0,0,0,151,0,250,0,90,0,0,0,0,0,62,0,239,0,68,0,0,0,127,0,159,0,91,0,116,0,159,0,0,0,0,0,233,0,192,0,149,0,120,0,185,0,219,0,36,0,39,0,0,0,4,0,252,0,92,0,212,0,244,0,0,0,50,0,252,0,0,0,178,0,139,0,71,0,226,0,51,0,212,0,37,0,157,0,232,0,42,0,29,0,253,0,238,0,161,0,44,0,4,0,0,0,132,0,168,0,222,0,0,0,205,0,62,0,191,0,20,0,193,0,0,0,199,0,26,0,79,0,72,0,0,0,10,0,229,0,0,0,128,0,73,0,87,0,116,0,96,0,92,0,202,0,0,0,168,0,130,0,31,0,46,0,108,0,77,0,52,0,249,0,16,0,0,0,1,0,188,0,190,0,37,0,37,0,70,0,8,0,0,0,254,0,234,0,226,0,127,0,229,0,30,0,15,0,251,0,123,0,156,0,139,0,0,0,0,0,183,0,139,0,0,0,59,0,86,0,180,0,110,0,166,0,186,0,162,0,180,0,198,0,224,0,246,0,0,0,0,0,158,0,235,0,211,0,182,0,19,0,0,0,184,0,104,0,19,0,0,0,78,0,6,0,31,0,247,0,196,0,14,0,0,0,187,0,124,0,62,0,9,0,157,0,253,0,230,0,169,0,203,0,40,0,0,0,239,0,33,0,213,0,19,0,173,0,219,0,140,0,138,0,0,0,0,0,186,0,136,0,250,0,30,0,0,0,3,0,122,0,0,0,91,0,190,0,58,0,207,0,58,0,204,0,201,0,0,0,0,0,194,0,0,0,185,0,197,0,153,0,0,0,42,0,228,0,238,0,220,0);
signal scenario_full  : scenario_type := (151,31,151,30,160,31,1,31,1,30,1,29,43,31,43,30,183,31,22,31,58,31,128,31,172,31,175,31,175,30,151,31,105,31,159,31,230,31,230,30,174,31,174,30,164,31,53,31,220,31,180,31,180,30,244,31,136,31,198,31,149,31,149,30,56,31,99,31,222,31,239,31,100,31,15,31,164,31,73,31,148,31,117,31,107,31,107,30,151,31,250,31,90,31,90,30,90,29,62,31,239,31,68,31,68,30,127,31,159,31,91,31,116,31,159,31,159,30,159,29,233,31,192,31,149,31,120,31,185,31,219,31,36,31,39,31,39,30,4,31,252,31,92,31,212,31,244,31,244,30,50,31,252,31,252,30,178,31,139,31,71,31,226,31,51,31,212,31,37,31,157,31,232,31,42,31,29,31,253,31,238,31,161,31,44,31,4,31,4,30,132,31,168,31,222,31,222,30,205,31,62,31,191,31,20,31,193,31,193,30,199,31,26,31,79,31,72,31,72,30,10,31,229,31,229,30,128,31,73,31,87,31,116,31,96,31,92,31,202,31,202,30,168,31,130,31,31,31,46,31,108,31,77,31,52,31,249,31,16,31,16,30,1,31,188,31,190,31,37,31,37,31,70,31,8,31,8,30,254,31,234,31,226,31,127,31,229,31,30,31,15,31,251,31,123,31,156,31,139,31,139,30,139,29,183,31,139,31,139,30,59,31,86,31,180,31,110,31,166,31,186,31,162,31,180,31,198,31,224,31,246,31,246,30,246,29,158,31,235,31,211,31,182,31,19,31,19,30,184,31,104,31,19,31,19,30,78,31,6,31,31,31,247,31,196,31,14,31,14,30,187,31,124,31,62,31,9,31,157,31,253,31,230,31,169,31,203,31,40,31,40,30,239,31,33,31,213,31,19,31,173,31,219,31,140,31,138,31,138,30,138,29,186,31,136,31,250,31,30,31,30,30,3,31,122,31,122,30,91,31,190,31,58,31,207,31,58,31,204,31,201,31,201,30,201,29,194,31,194,30,185,31,197,31,153,31,153,30,42,31,228,31,238,31,220,31);

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
