-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_415 is
end project_tb_415;

architecture project_tb_arch_415 of project_tb_415 is
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

constant SCENARIO_LENGTH : integer := 356;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (48,0,196,0,15,0,180,0,0,0,116,0,117,0,244,0,83,0,0,0,216,0,50,0,12,0,245,0,181,0,0,0,152,0,107,0,0,0,2,0,218,0,0,0,119,0,0,0,30,0,120,0,14,0,30,0,157,0,0,0,181,0,0,0,54,0,157,0,189,0,108,0,39,0,184,0,167,0,113,0,0,0,156,0,50,0,141,0,43,0,0,0,249,0,36,0,171,0,133,0,0,0,38,0,0,0,0,0,0,0,21,0,0,0,58,0,242,0,219,0,223,0,234,0,188,0,169,0,0,0,171,0,46,0,221,0,20,0,205,0,216,0,40,0,11,0,76,0,207,0,15,0,75,0,124,0,115,0,0,0,219,0,0,0,56,0,25,0,192,0,14,0,49,0,57,0,200,0,160,0,112,0,95,0,187,0,136,0,252,0,83,0,181,0,0,0,208,0,104,0,42,0,158,0,43,0,0,0,0,0,88,0,200,0,223,0,135,0,89,0,0,0,215,0,83,0,16,0,187,0,174,0,160,0,0,0,88,0,173,0,218,0,248,0,192,0,61,0,55,0,3,0,72,0,17,0,0,0,0,0,58,0,193,0,71,0,112,0,112,0,0,0,211,0,197,0,232,0,199,0,85,0,182,0,0,0,0,0,8,0,0,0,206,0,0,0,0,0,164,0,203,0,209,0,64,0,175,0,72,0,232,0,201,0,222,0,178,0,147,0,0,0,0,0,61,0,0,0,0,0,244,0,111,0,48,0,0,0,74,0,112,0,53,0,28,0,106,0,230,0,0,0,182,0,224,0,169,0,17,0,0,0,239,0,4,0,64,0,26,0,7,0,40,0,138,0,223,0,142,0,122,0,54,0,201,0,234,0,151,0,156,0,237,0,188,0,252,0,100,0,157,0,0,0,0,0,52,0,80,0,199,0,161,0,210,0,156,0,54,0,177,0,176,0,0,0,254,0,30,0,210,0,27,0,195,0,175,0,36,0,0,0,0,0,138,0,206,0,131,0,2,0,43,0,209,0,7,0,0,0,87,0,99,0,100,0,149,0,113,0,0,0,99,0,212,0,74,0,92,0,0,0,49,0,65,0,209,0,120,0,250,0,58,0,254,0,126,0,0,0,74,0,140,0,209,0,183,0,0,0,235,0,26,0,139,0,239,0,107,0,32,0,158,0,203,0,35,0,206,0,57,0,0,0,0,0,228,0,0,0,130,0,195,0,50,0,6,0,195,0,0,0,86,0,89,0,0,0,131,0,173,0,123,0,87,0,211,0,87,0,236,0,0,0,9,0,62,0,166,0,0,0,105,0,105,0,206,0,157,0,1,0,194,0,19,0,130,0,34,0,67,0,46,0,208,0,48,0,47,0,0,0,190,0,195,0,0,0,0,0,205,0,0,0,0,0,0,0,190,0,233,0,134,0,218,0,119,0,0,0,37,0,215,0,0,0,77,0,0,0,191,0,0,0,0,0,235,0,0,0,196,0,68,0,32,0,12,0,164,0,93,0,140,0,57,0,252,0,0,0,91,0,108,0,123,0,173,0,87,0,0,0,204,0,30,0,0,0,0,0,136,0,41,0,33,0,30,0,151,0,190,0);
signal scenario_full  : scenario_type := (48,31,196,31,15,31,180,31,180,30,116,31,117,31,244,31,83,31,83,30,216,31,50,31,12,31,245,31,181,31,181,30,152,31,107,31,107,30,2,31,218,31,218,30,119,31,119,30,30,31,120,31,14,31,30,31,157,31,157,30,181,31,181,30,54,31,157,31,189,31,108,31,39,31,184,31,167,31,113,31,113,30,156,31,50,31,141,31,43,31,43,30,249,31,36,31,171,31,133,31,133,30,38,31,38,30,38,29,38,28,21,31,21,30,58,31,242,31,219,31,223,31,234,31,188,31,169,31,169,30,171,31,46,31,221,31,20,31,205,31,216,31,40,31,11,31,76,31,207,31,15,31,75,31,124,31,115,31,115,30,219,31,219,30,56,31,25,31,192,31,14,31,49,31,57,31,200,31,160,31,112,31,95,31,187,31,136,31,252,31,83,31,181,31,181,30,208,31,104,31,42,31,158,31,43,31,43,30,43,29,88,31,200,31,223,31,135,31,89,31,89,30,215,31,83,31,16,31,187,31,174,31,160,31,160,30,88,31,173,31,218,31,248,31,192,31,61,31,55,31,3,31,72,31,17,31,17,30,17,29,58,31,193,31,71,31,112,31,112,31,112,30,211,31,197,31,232,31,199,31,85,31,182,31,182,30,182,29,8,31,8,30,206,31,206,30,206,29,164,31,203,31,209,31,64,31,175,31,72,31,232,31,201,31,222,31,178,31,147,31,147,30,147,29,61,31,61,30,61,29,244,31,111,31,48,31,48,30,74,31,112,31,53,31,28,31,106,31,230,31,230,30,182,31,224,31,169,31,17,31,17,30,239,31,4,31,64,31,26,31,7,31,40,31,138,31,223,31,142,31,122,31,54,31,201,31,234,31,151,31,156,31,237,31,188,31,252,31,100,31,157,31,157,30,157,29,52,31,80,31,199,31,161,31,210,31,156,31,54,31,177,31,176,31,176,30,254,31,30,31,210,31,27,31,195,31,175,31,36,31,36,30,36,29,138,31,206,31,131,31,2,31,43,31,209,31,7,31,7,30,87,31,99,31,100,31,149,31,113,31,113,30,99,31,212,31,74,31,92,31,92,30,49,31,65,31,209,31,120,31,250,31,58,31,254,31,126,31,126,30,74,31,140,31,209,31,183,31,183,30,235,31,26,31,139,31,239,31,107,31,32,31,158,31,203,31,35,31,206,31,57,31,57,30,57,29,228,31,228,30,130,31,195,31,50,31,6,31,195,31,195,30,86,31,89,31,89,30,131,31,173,31,123,31,87,31,211,31,87,31,236,31,236,30,9,31,62,31,166,31,166,30,105,31,105,31,206,31,157,31,1,31,194,31,19,31,130,31,34,31,67,31,46,31,208,31,48,31,47,31,47,30,190,31,195,31,195,30,195,29,205,31,205,30,205,29,205,28,190,31,233,31,134,31,218,31,119,31,119,30,37,31,215,31,215,30,77,31,77,30,191,31,191,30,191,29,235,31,235,30,196,31,68,31,32,31,12,31,164,31,93,31,140,31,57,31,252,31,252,30,91,31,108,31,123,31,173,31,87,31,87,30,204,31,30,31,30,30,30,29,136,31,41,31,33,31,30,31,151,31,190,31);

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
