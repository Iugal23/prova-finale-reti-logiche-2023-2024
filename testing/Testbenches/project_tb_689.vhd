-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_689 is
end project_tb_689;

architecture project_tb_arch_689 of project_tb_689 is
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

constant SCENARIO_LENGTH : integer := 413;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (123,0,165,0,0,0,0,0,171,0,117,0,149,0,112,0,82,0,8,0,183,0,109,0,198,0,0,0,235,0,182,0,115,0,49,0,224,0,0,0,195,0,0,0,0,0,21,0,201,0,49,0,0,0,65,0,183,0,23,0,0,0,0,0,1,0,187,0,56,0,199,0,48,0,150,0,182,0,0,0,128,0,211,0,75,0,25,0,0,0,107,0,254,0,29,0,0,0,209,0,0,0,181,0,148,0,196,0,215,0,118,0,161,0,37,0,224,0,120,0,219,0,229,0,80,0,231,0,190,0,0,0,70,0,0,0,0,0,0,0,124,0,106,0,32,0,63,0,0,0,44,0,58,0,48,0,186,0,0,0,128,0,229,0,0,0,0,0,182,0,119,0,99,0,30,0,11,0,0,0,234,0,198,0,103,0,0,0,0,0,224,0,0,0,0,0,69,0,0,0,31,0,230,0,0,0,0,0,100,0,49,0,138,0,0,0,0,0,35,0,214,0,181,0,234,0,136,0,22,0,0,0,0,0,0,0,162,0,208,0,0,0,153,0,0,0,0,0,95,0,74,0,244,0,148,0,142,0,223,0,134,0,151,0,0,0,0,0,212,0,132,0,15,0,0,0,155,0,80,0,0,0,253,0,122,0,137,0,230,0,142,0,0,0,123,0,195,0,247,0,226,0,237,0,228,0,177,0,165,0,91,0,217,0,133,0,136,0,91,0,117,0,122,0,238,0,253,0,163,0,195,0,117,0,183,0,37,0,0,0,0,0,111,0,100,0,0,0,134,0,0,0,251,0,0,0,236,0,227,0,0,0,55,0,0,0,158,0,211,0,68,0,0,0,2,0,14,0,243,0,0,0,0,0,1,0,96,0,55,0,0,0,26,0,53,0,166,0,0,0,192,0,0,0,0,0,173,0,0,0,175,0,0,0,133,0,0,0,0,0,36,0,240,0,0,0,67,0,179,0,59,0,0,0,0,0,44,0,196,0,0,0,139,0,0,0,190,0,0,0,109,0,168,0,0,0,126,0,124,0,246,0,117,0,6,0,5,0,174,0,58,0,83,0,80,0,55,0,175,0,0,0,149,0,226,0,193,0,75,0,195,0,0,0,174,0,0,0,142,0,0,0,240,0,218,0,175,0,8,0,211,0,0,0,0,0,0,0,176,0,75,0,60,0,235,0,5,0,248,0,0,0,189,0,132,0,177,0,142,0,100,0,75,0,0,0,0,0,141,0,0,0,28,0,97,0,228,0,0,0,0,0,82,0,225,0,152,0,87,0,0,0,252,0,14,0,0,0,0,0,52,0,232,0,59,0,44,0,175,0,65,0,0,0,89,0,151,0,232,0,96,0,130,0,48,0,221,0,0,0,155,0,0,0,72,0,143,0,189,0,156,0,175,0,0,0,119,0,0,0,243,0,105,0,226,0,148,0,90,0,0,0,251,0,87,0,249,0,222,0,85,0,73,0,193,0,63,0,13,0,117,0,23,0,0,0,161,0,30,0,16,0,0,0,38,0,0,0,139,0,0,0,24,0,61,0,210,0,117,0,236,0,251,0,126,0,196,0,253,0,44,0,207,0,103,0,129,0,67,0,245,0,96,0,46,0,84,0,8,0,160,0,227,0,165,0,179,0,159,0,138,0,52,0,96,0,0,0,94,0,253,0,141,0,222,0,124,0,0,0,61,0,32,0,174,0,0,0,20,0,54,0,0,0,52,0,175,0,14,0,139,0,109,0,80,0,89,0,0,0,224,0,249,0,202,0,168,0,6,0,100,0,211,0,6,0,0,0,125,0,236,0,1,0,0,0,49,0,177,0,102,0,50,0,244,0,11,0,0,0,0,0,32,0,83,0);
signal scenario_full  : scenario_type := (123,31,165,31,165,30,165,29,171,31,117,31,149,31,112,31,82,31,8,31,183,31,109,31,198,31,198,30,235,31,182,31,115,31,49,31,224,31,224,30,195,31,195,30,195,29,21,31,201,31,49,31,49,30,65,31,183,31,23,31,23,30,23,29,1,31,187,31,56,31,199,31,48,31,150,31,182,31,182,30,128,31,211,31,75,31,25,31,25,30,107,31,254,31,29,31,29,30,209,31,209,30,181,31,148,31,196,31,215,31,118,31,161,31,37,31,224,31,120,31,219,31,229,31,80,31,231,31,190,31,190,30,70,31,70,30,70,29,70,28,124,31,106,31,32,31,63,31,63,30,44,31,58,31,48,31,186,31,186,30,128,31,229,31,229,30,229,29,182,31,119,31,99,31,30,31,11,31,11,30,234,31,198,31,103,31,103,30,103,29,224,31,224,30,224,29,69,31,69,30,31,31,230,31,230,30,230,29,100,31,49,31,138,31,138,30,138,29,35,31,214,31,181,31,234,31,136,31,22,31,22,30,22,29,22,28,162,31,208,31,208,30,153,31,153,30,153,29,95,31,74,31,244,31,148,31,142,31,223,31,134,31,151,31,151,30,151,29,212,31,132,31,15,31,15,30,155,31,80,31,80,30,253,31,122,31,137,31,230,31,142,31,142,30,123,31,195,31,247,31,226,31,237,31,228,31,177,31,165,31,91,31,217,31,133,31,136,31,91,31,117,31,122,31,238,31,253,31,163,31,195,31,117,31,183,31,37,31,37,30,37,29,111,31,100,31,100,30,134,31,134,30,251,31,251,30,236,31,227,31,227,30,55,31,55,30,158,31,211,31,68,31,68,30,2,31,14,31,243,31,243,30,243,29,1,31,96,31,55,31,55,30,26,31,53,31,166,31,166,30,192,31,192,30,192,29,173,31,173,30,175,31,175,30,133,31,133,30,133,29,36,31,240,31,240,30,67,31,179,31,59,31,59,30,59,29,44,31,196,31,196,30,139,31,139,30,190,31,190,30,109,31,168,31,168,30,126,31,124,31,246,31,117,31,6,31,5,31,174,31,58,31,83,31,80,31,55,31,175,31,175,30,149,31,226,31,193,31,75,31,195,31,195,30,174,31,174,30,142,31,142,30,240,31,218,31,175,31,8,31,211,31,211,30,211,29,211,28,176,31,75,31,60,31,235,31,5,31,248,31,248,30,189,31,132,31,177,31,142,31,100,31,75,31,75,30,75,29,141,31,141,30,28,31,97,31,228,31,228,30,228,29,82,31,225,31,152,31,87,31,87,30,252,31,14,31,14,30,14,29,52,31,232,31,59,31,44,31,175,31,65,31,65,30,89,31,151,31,232,31,96,31,130,31,48,31,221,31,221,30,155,31,155,30,72,31,143,31,189,31,156,31,175,31,175,30,119,31,119,30,243,31,105,31,226,31,148,31,90,31,90,30,251,31,87,31,249,31,222,31,85,31,73,31,193,31,63,31,13,31,117,31,23,31,23,30,161,31,30,31,16,31,16,30,38,31,38,30,139,31,139,30,24,31,61,31,210,31,117,31,236,31,251,31,126,31,196,31,253,31,44,31,207,31,103,31,129,31,67,31,245,31,96,31,46,31,84,31,8,31,160,31,227,31,165,31,179,31,159,31,138,31,52,31,96,31,96,30,94,31,253,31,141,31,222,31,124,31,124,30,61,31,32,31,174,31,174,30,20,31,54,31,54,30,52,31,175,31,14,31,139,31,109,31,80,31,89,31,89,30,224,31,249,31,202,31,168,31,6,31,100,31,211,31,6,31,6,30,125,31,236,31,1,31,1,30,49,31,177,31,102,31,50,31,244,31,11,31,11,30,11,29,32,31,83,31);

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
