-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_754 is
end project_tb_754;

architecture project_tb_arch_754 of project_tb_754 is
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

constant SCENARIO_LENGTH : integer := 255;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (208,0,79,0,98,0,226,0,219,0,196,0,223,0,222,0,0,0,189,0,0,0,22,0,97,0,228,0,32,0,120,0,0,0,12,0,0,0,209,0,247,0,0,0,236,0,223,0,100,0,81,0,70,0,33,0,0,0,46,0,16,0,82,0,91,0,48,0,200,0,57,0,49,0,106,0,135,0,152,0,146,0,118,0,71,0,57,0,195,0,215,0,0,0,94,0,136,0,193,0,0,0,255,0,16,0,0,0,139,0,195,0,55,0,211,0,18,0,0,0,147,0,115,0,0,0,179,0,113,0,5,0,45,0,50,0,0,0,252,0,183,0,181,0,211,0,97,0,0,0,149,0,193,0,244,0,61,0,150,0,0,0,214,0,0,0,155,0,14,0,96,0,83,0,69,0,155,0,0,0,193,0,0,0,46,0,204,0,217,0,130,0,74,0,150,0,0,0,130,0,39,0,80,0,47,0,252,0,129,0,77,0,177,0,0,0,198,0,0,0,0,0,26,0,222,0,180,0,85,0,152,0,83,0,43,0,200,0,40,0,191,0,0,0,56,0,0,0,168,0,11,0,108,0,117,0,0,0,0,0,0,0,150,0,121,0,219,0,77,0,186,0,200,0,248,0,252,0,38,0,39,0,226,0,0,0,0,0,0,0,143,0,111,0,196,0,0,0,0,0,15,0,6,0,101,0,230,0,128,0,95,0,0,0,165,0,124,0,57,0,0,0,61,0,165,0,126,0,8,0,93,0,0,0,51,0,0,0,0,0,19,0,57,0,92,0,0,0,0,0,0,0,25,0,193,0,184,0,207,0,3,0,113,0,113,0,4,0,201,0,1,0,0,0,216,0,173,0,0,0,183,0,13,0,140,0,100,0,129,0,243,0,241,0,219,0,224,0,96,0,89,0,30,0,178,0,135,0,89,0,116,0,55,0,0,0,0,0,37,0,206,0,209,0,142,0,122,0,176,0,97,0,0,0,0,0,24,0,175,0,134,0,45,0,213,0,0,0,177,0,107,0,181,0,40,0,40,0,129,0,129,0,0,0,63,0,111,0,18,0,205,0,0,0,129,0,245,0,0,0,6,0,135,0,252,0,7,0,11,0,225,0,93,0,154,0,184,0,236,0,162,0,56,0,0,0,162,0,37,0);
signal scenario_full  : scenario_type := (208,31,79,31,98,31,226,31,219,31,196,31,223,31,222,31,222,30,189,31,189,30,22,31,97,31,228,31,32,31,120,31,120,30,12,31,12,30,209,31,247,31,247,30,236,31,223,31,100,31,81,31,70,31,33,31,33,30,46,31,16,31,82,31,91,31,48,31,200,31,57,31,49,31,106,31,135,31,152,31,146,31,118,31,71,31,57,31,195,31,215,31,215,30,94,31,136,31,193,31,193,30,255,31,16,31,16,30,139,31,195,31,55,31,211,31,18,31,18,30,147,31,115,31,115,30,179,31,113,31,5,31,45,31,50,31,50,30,252,31,183,31,181,31,211,31,97,31,97,30,149,31,193,31,244,31,61,31,150,31,150,30,214,31,214,30,155,31,14,31,96,31,83,31,69,31,155,31,155,30,193,31,193,30,46,31,204,31,217,31,130,31,74,31,150,31,150,30,130,31,39,31,80,31,47,31,252,31,129,31,77,31,177,31,177,30,198,31,198,30,198,29,26,31,222,31,180,31,85,31,152,31,83,31,43,31,200,31,40,31,191,31,191,30,56,31,56,30,168,31,11,31,108,31,117,31,117,30,117,29,117,28,150,31,121,31,219,31,77,31,186,31,200,31,248,31,252,31,38,31,39,31,226,31,226,30,226,29,226,28,143,31,111,31,196,31,196,30,196,29,15,31,6,31,101,31,230,31,128,31,95,31,95,30,165,31,124,31,57,31,57,30,61,31,165,31,126,31,8,31,93,31,93,30,51,31,51,30,51,29,19,31,57,31,92,31,92,30,92,29,92,28,25,31,193,31,184,31,207,31,3,31,113,31,113,31,4,31,201,31,1,31,1,30,216,31,173,31,173,30,183,31,13,31,140,31,100,31,129,31,243,31,241,31,219,31,224,31,96,31,89,31,30,31,178,31,135,31,89,31,116,31,55,31,55,30,55,29,37,31,206,31,209,31,142,31,122,31,176,31,97,31,97,30,97,29,24,31,175,31,134,31,45,31,213,31,213,30,177,31,107,31,181,31,40,31,40,31,129,31,129,31,129,30,63,31,111,31,18,31,205,31,205,30,129,31,245,31,245,30,6,31,135,31,252,31,7,31,11,31,225,31,93,31,154,31,184,31,236,31,162,31,56,31,56,30,162,31,37,31);

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
